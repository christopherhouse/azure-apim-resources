param nsgName string
param location string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowMgmtTrafficToVnet'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          description: 'Allow management traffic to vnet'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'ApiManagement'
          destinationPortRange: '3443'
          destinationAddressPrefix: 'VirtualNetwork'
        }
      }
      {
        name: 'AllowHttpAndHttTrafficToVnet'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          description: 'Allow http + https traffic to vnet'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
        }
      }
      {
        name: 'AllowKeyVaultTrafficOutbound'
        properties: {
          priority: 120
          direction: 'Outbound'
          access: 'Allow'
          description: 'Allow management traffic to vnet'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '3443'
          destinationAddressPrefix: 'AzureKeyVault'
        }
      }       
    ]
  }
}

output id string = nsg.id
