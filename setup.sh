#!/bin/bash

# SaaS Analytics Project Setup Script

set -e

echo "🚀 Setting up SaaS Analytics Project..."
echo ""

# Check Python version
echo "📋 Checking Python version..."
python3 --version

# Install root requirements
echo ""
echo "📦 Installing root dependencies..."
pip install -r requirements.txt

# Install data generation dependencies
echo ""
echo "📦 Installing data generation dependencies..."
cd data_generation
pip install -r requirements.txt
cd ..

# Generate data
echo ""
echo "📊 Generating synthetic SaaS data..."
cd data_generation
python generate_saas_data.py
cd ..

# Set up dbt
echo ""
echo "🔧 Setting up dbt project..."
cd dbt_project
dbt deps
echo ""
echo "✅ Running dbt debug..."
dbt debug
cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. cd dbt_project"
echo "  2. dbt run    # Build all models"
echo "  3. dbt test   # Run all tests"
echo "  4. dbt docs generate && dbt docs serve  # View documentation"
echo ""
