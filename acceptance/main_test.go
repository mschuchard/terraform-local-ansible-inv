package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformHelloWorldExample(test *testing.T) {
	// construct tf options with path to acceptance test root module config dir
	terraformOptions := terraform.WithDefaultRetryableErrors(test, &terraform.Options{
		// of course it is the current dir
		TerraformDir: ".",
	})

	// defer destroy
	defer terraform.Destroy(test, terraformOptions)

	// invoke acceptance test execution
	terraform.InitAndApply(test, terraformOptions)

	// validate outputs
	invFiles := terraform.Output(test, terraformOptions, "inventory_files")
	assert.Equal(test, "[./inventory.ini ./inventory.json ./inventory.yaml]", invFiles)
}
