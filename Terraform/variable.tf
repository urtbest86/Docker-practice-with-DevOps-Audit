// basic variable
variable "endalgo_rg" {
  type    = string
  default = "endalgo-prd-rg"
}

variable "endalgo_db_rg" {
  type    = string
  default = "endalgo-prd-db-rg"
}

variable "location" {
  type    = string
  default = "koreacentral"
}

// network variable
variable "endalgo_vnet" {
  type    = string
  default = "endalgo-prd-vnet-001"
}

variable "endalgo_snet_001" {
  type    = string
  default = "endalgo-prd-snet-001"
}

// cosmos db variable
variable "endalgo_cosmosdb_acc" {
  type    = string
  default = "endalgo-prd-cosmosdb-acc-001"
}

variable "cosmos_db_account_name" {
  type    = string
  default = "endalgo-prd-cosmos-db-001"
}

variable "failover_location" {
  type    = string
  default = "australiacentral"
}

// web app
variable "endalgo_plan" {
  type    = string
  default = "endalgo-prd-plan-001"
}

variable "endalgo_webapp" {
  type    = string
  default = "endalgo-prd-webapp-001"
}
