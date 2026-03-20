variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "prod_alias_version" {
  type        = string
  description = "Published version number the prod alias points to (e.g. \"1\"). Bump after you promote a new release."
  default     = "1"
}

variable "build_tag" {
  type        = string
  description = "Env var returned in JSON; change and re-apply to see a new published version vs prod alias."
  default     = "v1"
}

# ---------------------------------------------------------------------------
# 50/50 (or custom) split on the "test" alias between two *published* versions
# ---------------------------------------------------------------------------
# Requires BOTH versions to already exist in AWS (publish = true on function).
# Typical flow: apply once → v1; change build_tag/index → apply → v2; then set
# test_traffic_split_enabled = true and apply again.

variable "test_traffic_split_enabled" {
  type        = bool
  description = "If true, test alias sends (1 - secondary_weight) to primary_version and secondary_weight to secondary_version."
  default     = false
}

variable "test_traffic_primary_version" {
  type        = string
  description = "Published version receiving the remainder of traffic when split is enabled (e.g. \"1\")."
  default     = "1"
}

variable "test_traffic_secondary_version" {
  type        = string
  description = "Second published version for weighted routing (e.g. \"2\")."
  default     = "2"
}

variable "test_traffic_secondary_weight" {
  type        = number
  description = "Fraction of traffic to secondary_version (0–1). AWS sends the rest to primary_version."
  default     = 0.5
}
