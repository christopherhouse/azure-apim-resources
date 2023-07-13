param resourceNamePrefix string
param resourceNameBaseName string
param environmentName string
param location string
//param additionalApimRegions array

@allowed(['notIntegrated'
'internalWithAppGateway'
'externalWithFrontDoorPremium'])
param apimNetworkConfiguration string
param vnetAddressSpace string = ''
param subnets array = []

var virtualNetworkName = '${resourceNamePrefix}-${resourceNameBaseName}-${environmentName}-vnet'

module vnet './modules/virtualNetwork.bicep' = if ((apimNetworkConfiguration == 'internalWithAppGateway') || (apimNetworkConfiguration == 'externalWithFrontDoorPremium')) {
  name: '${resourceNamePrefix}vnet'
  params: {
    addressSpace: vnetAddressSpace
    virtualNetworkName: virtualNetworkName
    subnets: subnets
    location: location
  }
}
