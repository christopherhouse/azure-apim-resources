param virtualNetworkName string
param addressSpace string
param apimSubnetPrefix string
param keyVaultSubnetPrefix string
param apimNsgId string
param location string

var keyVaultSubnet = {
  name: 'KeyVault'
  properties: {
    addressPrefix: keyVaultSubnetPrefix
  }
}

var apimSubnet = {
  name: 'APIM'
  properties: {
    addressPrefix: apimSubnetPrefix
    networkSecurityGroup: {
      id: apimNsgId
    }
  }
}

var subnets = [
  keyVaultSubnet
  apimSubnet
]

resource vnet'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: subnets
  }
}

output apimSubnetId string = resourceId(vnet.id, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'APIM')
