param location string = resourceGroup().location
param namePrefix string = 'stg'

param globalRedundancy bool = true
//@minLength(3)
//@maxLength(24)
//param storageAccountName string = 'mybicepstorageaa'

//var storageSku = 'Standard_LRS'
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
