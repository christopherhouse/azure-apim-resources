param apimName string
param location string
param subnetId string
@allowed([
  'External'
  'Internal'
  'None'
])
param virtualNetworkMode string
@allowed([
  'Basic'
  'Standard'
  'Premium'
  'Developer'
])
param skuName string = 'Developer'
param skuCapacity int = 1
param apimPublisherName string
param apimPublisherEmail string
param publicIpAddressId string = ''

var vnetConfiguration = subnetId != null ? {
  subnetResourceId: subnetId
} : {}

resource apim 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apimName
  location: location
  sku: {
    capacity: skuCapacity
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
    virtualNetworkType: virtualNetworkMode
    virtualNetworkConfiguration: vnetConfiguration
    publicIpAddressId: publicIpAddressId
  }
}

output gatewayEndpoint string = replace(replace(apim.properties.gatewayUrl, 'https://', ''), '/', '')
output managementApiEndpoint string = replace(replace(apim.properties.managementApiUrl, 'https://', ''), '/', '')
