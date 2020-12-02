terraform {
    backend "gcs" {
        bucket = "tfstates-address-validate-lab"
        prefix = "libpostal-api/prod"
    }
}