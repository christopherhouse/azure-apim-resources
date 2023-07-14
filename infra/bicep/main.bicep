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
param deployWafSolution bool = true

// Deployment names
var apimNsgDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apimnsg-${buildId}'
var vnetDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-vnet-${buildId}'
var apimDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apim-${buildId}'
var pipDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-pip-${buildId}'
var frontDoorDeploymentName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-afd-${buildId}'

// Resource names
var virtualNetworkName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-vnet'
var nsgName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-nsg'
var apimName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-apim-${buildId}'
var pipName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-pip'
var frontDoorName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-afd'

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

module apimPip './modules/publicIpAddress.bicep' = {
  name: pipDeploymentName
  params: {
    publicIpAddressName: pipName
    location: location
    dnsLabel: apimName
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
    publicIpAddressId: apimPip.outputs.id
  }
}

module frontDoor './modules/azureFrontDoor.bicep' = {
  name: ''
  params: {
    apimGatewayEndpoint: apim.outputs.gatewayEndpoint
    frontDoorBaseName: frontDoorName
  }
}
