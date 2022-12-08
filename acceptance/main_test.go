package test

import (
  "os"
  "testing"

  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
)

func TestTerraformLocalAnsibleInv(test *testing.T) {
  // construct tf options with path to acceptance test root module config dir
  terraformOptions := terraform.WithDefaultRetryableErrors(test, &terraform.Options{
    // of course it is the current dir
    TerraformDir: ".",
  })

  // defer destroy
  defer terraform.Destroy(test, terraformOptions)

  // invoke acceptance test execution
  terraform.InitAndApply(test, terraformOptions)

  // validate files outputs
  invFilesOutput := terraform.OutputList(test, terraformOptions, "inventory_files")
  assert.Equal(test, []string{"./inventory.ini", "./inventory.json", "./inventory.yaml"}, invFilesOutput)

  // validate inventory content outputs and then file content directly
  for _, format := range []string{"ini", "yaml", "json"} {
    acceptance, _ := os.ReadFile("acceptance." + format)

    // inventory outputs
    output := terraform.Output(test, terraformOptions, "inventory_" + format)
    assert.Equal(test, string(acceptance), output)

    // inventory file content
    inventoryFileContent, _ := os.ReadFile("inventory." + format)
    assert.Equal(test, string(acceptance), string(inventoryFileContent))
  }
}
