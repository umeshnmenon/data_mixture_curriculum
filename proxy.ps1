param([string]$OutputDir = $PSScriptRoot)
$ErrorActionPreference='Stop'
# Structural experiment only. Scores are deliberately biased synthetic fixtures,
# not OPUS gradients or language-model capability measurements.
$lanes=@('web','code','stem','indic','reasoning','long','agentic')
$shares=@(40,25,10,15,4,5,1)
$floors=@(0,0,0,10,2,0,1)
$rows=@()
foreach($seed in 1..10){
 $rng=[Random]::new($seed)
 foreach($batch in 1..20){
  $candidates=@(); $id=0
  for($j=0;$j -lt 7;$j++){
   # 2.5x candidates per quota; top-40% selection overall.
   for($k=0;$k -lt ($shares[$j]*25);$k++){
    $bias=if($j -in @(3,4,6)){0.0}else{0.8}
    $candidates += [pscustomobject]@{id=$id;lane=$j;score=$bias+$rng.NextDouble()}; $id++
   }
  }
  $unprotected=@($candidates | Sort-Object score -Descending | Select-Object -First 1000)
  $protected=@()
  # Allocate protected floors first, then enforce lane quotas on remainder.
  # This prevents a biased selector changing the declared mixture.
  for($j=0;$j -lt 7;$j++){
   $pool=@($candidates | Where-Object lane -EQ $j | Sort-Object score -Descending)
   $protected+=@($pool | Select-Object -First ($floors[$j]*10))
   $protected+=@($pool | Select-Object -Skip ($floors[$j]*10) -First (($shares[$j]-$floors[$j])*10))
  }
  foreach($mode in @('global','quota_protected')){
   $selected=if($mode -eq 'global'){$unprotected}else{$protected}
   for($j=0;$j -lt 7;$j++){
    $count=@($selected | Where-Object lane -EQ $j).Count
    $rows += [pscustomobject]@{seed=$seed;batch=$batch;mode=$mode;lane=$lanes[$j];selected=$count;share_pct=$count/10;floor_pct=$floors[$j];floor_ok=($count -ge $floors[$j]*10)}
   }
   if($selected.Count -ne 1000){throw 'Batch budget mismatch'}
   if(@($selected.id | Select-Object -Unique).Count -ne 1000){throw 'Duplicate within batch'}
  }
 }
}
$rows | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $OutputDir 'proxy-batches.csv')
$summary=foreach($mode in @('global','quota_protected')){foreach($lane in $lanes){
 $r=@($rows | Where-Object { $_.mode -eq $mode -and $_.lane -eq $lane })
 [pscustomobject]@{mode=$mode;lane=$lane;mean_share_pct=($r.share_pct|Measure-Object -Average).Average;min_share_pct=($r.share_pct|Measure-Object -Minimum).Minimum;floor_violations=@($r|Where-Object floor_ok -EQ $false).Count}
}}
$summary | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $OutputDir 'proxy-summary.csv')
# A trajectory fixture: user, assistant plan, call, failed observation,
# recovery call, successful observation, final answer. Unit = fixture token.
$roles=@('user','assistant','assistant','tool','assistant','tool','assistant')
$lengths=@(20,30,15,100,20,200,40)
$mask=@();for($i=0;$i -lt $roles.Count;$i++){for($t=0;$t -lt $lengths[$i];$t++){$mask+=($roles[$i] -eq 'assistant')}}
$supervised=@($mask|Where-Object {$_}).Count
if($supervised -ne 105 -or $mask.Count -ne 425){throw 'Mask fixture failed'}
# Reserve identity test with intentionally injected overlap as negative control.
$main=1..900;$reserve=901..1000
$overlap=@($reserve|Where-Object {$_ -in $main}).Count
$badReserve=@(900)+$reserve
$detected=@($badReserve|Where-Object {$_ -in $main}).Count
if($overlap -ne 0 -or $detected -ne 1){throw 'Reserve isolation failed'}
# L1 distribution-change audit; no synthetic gradient claims.
$old=@(44,25,10,15,3,3,0);$new=@(27,31,10,18,6,6,2)
$hard=0;for($j=0;$j -lt 7;$j++){$hard+=[Math]::Abs($new[$j]-$old[$j])}
$checks=[ordered]@{experiment='structural proxy, NOT 1B/3B training';seeds=10;batches_per_seed=20;candidate_units_per_batch=2500;retained_units_per_batch=1000;token_unit='equal-length simulated blocks';masked_fixture_total=425;masked_fixture_supervised=105;tool_tokens_supervised=0;reserve_overlap=$overlap;negative_control_overlap_detected=$detected;hard_transition_L1_percentage_points=$hard;ramp_100_steps_max_L1_percentage_points=$hard/100;capability_metrics_measured=$false}
$checks|ConvertTo-Json|Set-Content -Encoding UTF8 (Join-Path $OutputDir 'proxy-checks.json')
$summary|Format-Table -AutoSize
$checks|ConvertTo-Json
