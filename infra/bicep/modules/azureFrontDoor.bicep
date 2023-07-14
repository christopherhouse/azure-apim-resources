param frontDoorBaseName string
@allowed([
  'Premium_AzureFrontDoor'
])
param frontDoorSku string = 'Premium_AzureFrontDoor'
param apimGatewayEndpoint string
//param apimManagementApiEndpoint string
//param apimPortalEndpoint string
@allowed([
  'Prevention'
  'Detection'
])
param wafMode string = 'Prevention'
param wafManagedRulesets array = [
  {
    rulesetType: 'Microsoft_DefaultRuleSet'
    ruleSetVersion: '2.1'
    rulesetAction: 'Block'
  }
  {
    ruleSetType: 'Microsoft_BotManagerRuleSet'
    ruleSetVersion: '1.0'
  }
]

var profileName = '${frontDoorBaseName}-profile'
var originName = '${frontDoorBaseName}-origingroup'
var gatewayEndpointName = '${frontDoorBaseName}-gateway-endpoint'
//var managementApiEndpointName = '${frontDoorBaseName}-management-api-endpoint'
//var portalEndpointName = '${frontDoorBaseName}-portal-endpoint'
var sku = frontDoorSku


resource wafPolicy 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2022-05-01' = {
  name: '${replace(frontDoorBaseName, '-', '')}wafpolicy'
  location: 'global'
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: wafMode
    }
    managedRules: {
      managedRuleSets: wafManagedRulesets
    }
  }
}

resource securityPolicy 'Microsoft.Cdn/profiles/securityPolicies@2022-11-01-preview' = {
  name: '${replace(frontDoorBaseName, '-', '')}securitypolicy'
  parent: frontDoorProfile
  properties: {
    parameters: {
      type: 'WebApplicationFirewall'
      wafPolicy: {
        id: wafPolicy.id
      }
      associations: [
        {
          domains: [
            {
              id: gatewayEndpoint.id
            }
          ]
          patternsToMatch: [
            '/*'
          ]
        }
      ]
    }
  }
}

resource frontDoorProfile 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: profileName
  location: 'global'
  sku: {
    name: sku
  }
}

resource gatewayEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2022-11-01-preview' = {
  name: gatewayEndpointName
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource gatewayOriginGroup 'Microsoft.Cdn/profiles/originGroups@2022-11-01-preview' = {
  name: originName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 2
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'GET'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 30
    }
  }
}

resource gatewayOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2022-11-01-preview' = {
  name: 'apim-gateway-origin-group'
  parent: gatewayOriginGroup
  properties: {
    hostName: apimGatewayEndpoint
    httpPort: 80
    httpsPort: 443
    originHostHeader: apimGatewayEndpoint
    priority: 1
    weight: 1000
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2022-11-01-preview' = {
  name: 'apim-gateway-route'
  parent: gatewayEndpoint
  properties: {
    originGroup: {
      id: gatewayOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    cacheConfiguration: {
      queryStringCachingBehavior: 'IgnoreQueryString'
    }
  }
  dependsOn: [
    gatewayOrigin
  ]
}

//output frontDoorId string = frontDoorProfile.properties.frontDoorId
