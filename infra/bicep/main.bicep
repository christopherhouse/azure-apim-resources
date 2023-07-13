param resourceNamePrefix string
param resourceNameBaseName string
param environmentName string
param location string
//param additionalApimRegions array
@allowed([
  'Internal'
  'External'
  'None'
]
)
param virtualNetworkType string
param vnetAddressSpace string
param apimSubnetPrefix string
param keyVaultSubnetPrefix string
param buildId string
param apimSkuName string = 'Developer'
param apimSkuCapacity int = 1
param apimPublisherName string
param apimPublisherEmail string

var apimNsgDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apimnsg-${buildId}'
var vnetDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-vnet-${buildId}'
var apimDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apim-${buildId}}'

// Resource names
var virtualNetworkName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-vnet'
var nsgName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-nsg'
var apimName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apim'

module apimNsg './modules/apimNetworkSecurityGroup.bicep' = if (virtualNetworkType != 'None') {
  name: apimNsgDeploymentName
  params: {
    nsgName: nsgName
    location: location
  }
}

module vnet './modules/virtualNetwork.bicep' = if (virtualNetworkType != 'None') {
  name: vnetDeploymentName
  params: {
    addressSpace: vnetAddressSpace
    virtualNetworkName: virtualNetworkName
    location: location
    apimNsgId: apimNsg.outputs.id
    apimSubnetPrefix: apimSubnetPrefix
    keyVaultSubnetPrefix: keyVaultSubnetPrefix
  }
}

module apim './modules/apiManagement.bicep' = {
  name: apimDeploymentName
  params: {
    location: location
    apimName: apimName
    apimPublisherEmail: apimPublisherEmail
    apimPublisherName: apimPublisherName
    subnetId: vnet.outputs.apimSubnetId
    virtualNetworkMode: 'External'
    skuName: apimSkuName
    skuCapacity: apimSkuCapacity
  }
}
