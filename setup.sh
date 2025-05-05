#!/bin/bash

# Create a new directory for the Rego policy bundle
mkdir -p rego-policies/policies

# Create example policy files
cat > rego-policies/policies/example.rego << 'EOF'
package example

default allow = false

allow {
    input.user.role == "admin"
}
EOF

cat > rego-policies/policies/common.rego << 'EOF'
package common

is_authenticated {
    input.user.authenticated == true
}
EOF

# Create a README file with instructions
cat > rego-policies/README.md << 'EOF'
# Rego Policy Bundle

This directory contains Rego policies for use with OPA (Open Policy Agent).

## Directory Structure
