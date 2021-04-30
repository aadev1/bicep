//Using Bicep Expressions
//https://github.com/Azure/bicep/blob/main/docs/tutorial/03-using-expressions.md

/*
param location string = resourceGroup().location
param namePrefix string = 'stg'

param globalRedundancy bool = true

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'Storage'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
}

output storageId string = stg.id
*/

// Using the symbolic resource name
//https://github.com/Azure/bicep/blob/main/docs/tutorial/04-using-symbolic-resource-name.md

/*
param location string = resourceGroup().location
param namePrefix string = 'stg'

param globalRedundancy bool = true

var storageAccountName = '${namePrefix}aabiceptest'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'Storage'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${stg.name}/default/logs'
  // dependsOn will be added when the template is compiled
}

output storageId string = stg.id
output computeStorageName string = stg.name
output blobEndpoint string = stg.properties.primaryEndpoints.blob // replacement for reference()
*/

// Advanced resource declarations with loops, conditions, and "existing"
// https://github.com/Azure/bicep/blob/main/docs/tutorial/05-loops-conditions-existing.md

/*
param namePrefix string = 'stg'

var storageAccountName = '${namePrefix}aabiceptest'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${stg.name}/default/logs2'
}

output storageId string = stg.id
output blobEndpoint string = stg.properties.primaryEndpoints.blob // replacement for reference()
*/

// Conditions
/*
param namePrefix string = 'stg'

var storageAccountName = '${namePrefix}aabiceptest'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

param currentYear string = utcNow('yyyy')

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = if(currentYear == '2021') {
  name: '${stg.name}/default/logs3'
}
*/

// Loops
param namePrefix string = 'stg'

var storageAccountName = '${namePrefix}aabiceptest'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

param containerNames array = [
  'dogs'
  'cats'
  'fish'
]

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = [for name in containerNames: {
  name: '${stg.name}/default/${name}'
}]

// There's also a loop index variant which gives us access to the current item's index in the array:
resource blob2 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for (name, index) in containerNames: {
  name: '${stg.name}/default/${name}-${index + 1}'
}]

output containerProps array = [for i in range(0, length(containerNames)): blob[i].id]
