Problem:
AKS deployment failed because VM size was not available.

Error:
The VM size Standard_B2s is not allowed in the
subscription/location.

Investigation:

az vm list-skus ...

Resolution:
Check SKU availability for the selected region and
subscription before deploying AKS.

Lesson:
Never assume that a VM SKU available in Azure documentation
is automatically available in a particular subscription and region.
