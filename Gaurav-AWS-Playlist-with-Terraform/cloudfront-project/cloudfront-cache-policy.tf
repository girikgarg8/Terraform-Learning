# Cache policy: query params in cache key (e.g. ?page=2&size=5), custom TTLs
resource "aws_cloudfront_cache_policy" "api" {
  name        = "${var.project_name}-api-cache"
  comment     = "Query params in cache key; min/max/default TTL for API"
  default_ttl = var.cache_default_ttl
  max_ttl     = var.cache_max_ttl
  min_ttl     = var.cache_min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}
