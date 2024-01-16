package test

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformLocalAnsibleInv(test *testing.T) {
	// determine config directory path for tf command positional arg
	_, file, _, ok := runtime.Caller(0)
	if !ok {
		test.Error("unable to determine the current file")
		return
	}
	directory := filepath.Dir(file)

	// construct tf options with path to acceptance test root module config dir
	terraformOptions := terraform.WithDefaultRetryableErrors(test, &terraform.Options{TerraformDir: directory})

	// defer destroy
	defer terraform.Destroy(test, terraformOptions)

	// invoke acceptance test execution
	terraform.InitAndApply(test, terraformOptions)

	// validate files outputs
	invFilesOutput := terraform.OutputList(test, terraformOptions, "inventory_files")
	assert.Equal(test, []string{"./inventory.ini", "./inventory.json", "./inventory.yaml"}, invFilesOutput)

	// validate inventory content outputs and then file content directly
	for _, format := range []string{"ini", "yaml", "json"} {
		// assign expected acceptance test inventory content from fixture
		acceptance, err := os.ReadFile("acceptance." + format)
		if err != nil {
			test.Errorf("issue with acceptance test content fixture file for %s format", format)
			test.Error(err)
			continue
		}

		// inventory outputs
		output := terraform.Output(test, terraformOptions, "inventory_"+format)
		assert.Equal(test, string(acceptance), output)

		// inventory file content
		inventoryFileContent, err := os.ReadFile("inventory." + format)
		if err != nil {
			test.Errorf("issue with reading inventory file for %s format", format)
			test.Error(err)
			continue
		}
		assert.Equal(test, string(acceptance), string(inventoryFileContent))
	}
}
