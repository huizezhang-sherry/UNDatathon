test_that("split_time() works", {
  res <- test_ala |> split_time()
  expect_snapshot(res[[1]])
})
