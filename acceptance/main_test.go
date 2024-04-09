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
	if _, err := terraform.InitAndApplyAndIdempotentE(test, terraformOptions); err != nil {
		test.Error("init, apply, or post-apply plan failed")
		test.Error(err)
		return
	}

	// validate "inv_files" output
	if invFilesOutput, err := terraform.OutputListE(test, terraformOptions, "inventory_files"); err != nil {
		test.Error("the 'inv_files' output could not be resolved correctly, and will not be validated")
		test.Error(err)
	} else {
		assert.Equal(test, invFilesOutput, []string{"./inventory.ini", "./inventory.json", "./inventory.yaml"})
	}

	// validate inventory content outputs and then file content directly
	for _, format := range []string{"ini", "yaml", "json"} {
		// assign expected acceptance test inventory content from fixture
		acceptance, err := os.ReadFile(directory + "/acceptance." + format)
		if err != nil {
			test.Errorf("issue with reading acceptance test fixture file for %s format", format)
			test.Error(err)
			continue
		}

		// inventory output's string content is equal to output file's content
		if output, err := terraform.OutputE(test, terraformOptions, "inventory_"+format); err != nil {
			test.Errorf("the Terraform output for the '%s' format could not be returned, and it will not be compated to the corresponding file content", format)
			test.Error(err)
		} else {
			assert.Equal(test, output, string(acceptance))
		}

		// inventory file content is equal to expected
		inventoryFileContent, err := os.ReadFile(directory + "/inventory." + format)
		if err != nil {
			test.Errorf("issue with reading inventory file for %s format", format)
			test.Error(err)
			continue
		}

		assert.Equal(test, string(inventoryFileContent), string(acceptance))
	}
}
