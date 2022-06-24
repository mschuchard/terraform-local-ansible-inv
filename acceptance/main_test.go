package test

import (
  "io/ioutil"
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

  // validate files outputs
  invFilesOutput := terraform.Output(test, terraformOptions, "inventory_files")
  assert.Equal(test, "[./inventory.ini ./inventory.json ./inventory.yaml]", invFilesOutput)

  // validate inventory outputs
  for _, format := range []string{"ini", "yaml", "json"} {
    output := terraform.Output(test, terraformOptions, "inventory_" + format)
    acceptance, _ := ioutil.ReadFile("acceptance." + format)
    assert.Equal(test, string(acceptance), output)
  }
}
