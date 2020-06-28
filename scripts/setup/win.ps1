# PARAMS
Param(
    [Alias("a")]
    [parameter(
        Mandatory=$true,
        HelpMessage="Scratch Org Alias that will be used for this Org"
    )][string]$alias,
    [Alias("d")]
    [int]$duration = 7,
    [Alias("f")]
    [string]$configFile = 'config/default-scratch-def.json'
)

# always create force-app folder
Write-Host "md -Force force-app | Out-Null"
md -Force force-app | Out-Null

Write-Host "sfdx force:org:create -d $duration -f $configFile -a $alias -s"
sfdx force:org:create -d $duration -f $configFile -a $alias -s

Write-Host "sfdx force:source:push -u $alias"
sfdx force:source:push -u $alias

Write-Host "sfdx force:user:permset:assign -n Address_Demo_Administrator -u $alias"
sfdx force:user:permset:assign -n Address_Demo_Administrator -u $alias

Write-Host "sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias"
sfdx force:data:tree:import -p data/plans/standard-plan.json -u $alias

Write-Host "sfdx force:apex:execute -f scripts/apex/createPrices.apex -u $alias | Out-Null"
sfdx force:apex:execute -f scripts/apex/createPrices.apex -u $alias | Out-Null

Write-Host "sfdx force:apex:execute -f scripts/apex/createLineItems.apex -u $alias | Out-Null"
sfdx force:apex:execute -f scripts/apex/createLineItems.apex -u $alias | Out-Null

Write-Host "sfdx force:org:open -u $alias"
sfdx force:org:open -u $alias