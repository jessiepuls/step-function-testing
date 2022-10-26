module "deploy_locker" {
  source        = "../../modules/lambda"
  code_path     = "../../../services/locker/locker"
  function_name = "locker"
  environment   = "local"
  handler       = "locker"
}

module "step_fn" {
  source        = "../../modules/step-function"
  fn_name = "testing-step-functions"
  lambda_arn = module.deploy_locker.fn.arn
}