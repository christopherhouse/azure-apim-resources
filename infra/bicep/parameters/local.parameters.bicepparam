using '../main.bicep'

param resourceNamePrefix = 'cmh'
param resourceNameBaseName = 'apim-template'
param environmentName = 'local'
param location = 'eastus'
param virtualNetworkType = 'External'
param vnetAddressSpace = '10.0.0.0/16'
param apimSubnetPrefix = '10.0.0.0/24'
param keyVaultSubnetPrefix = '10.0.1.0/24'
param buildId = '1'
param apimPublisherEmail = 'chhouse@microsoft.com'
param apimPublisherName = 'Chris House'
param apimSkuCapacity = 1
param apimSkuName = 'Developer'
param deployWafSolution = true
