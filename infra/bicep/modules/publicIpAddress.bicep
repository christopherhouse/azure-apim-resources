param publicIpAddressName string
param dnsLabel string
param location string

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: dnsLabel
    }
    publicIPAllocationMethod: 'Static'
  }
}

output id string = publicIp.id
