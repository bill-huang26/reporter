context("Report Spec Tests")


test_that("create_report sets default values appropriately", {
  
  ret <- create_report()
  
  expect_equal(ret$orientation, "landscape")
  expect_equal(ret$output_type, "TXT")
  
})


test_that("create_report changes parameters appropriately", {
  
  ret <- create_report(output_type = "txt", orientation = "portrait")
  
  expect_equal(ret$orientation, "portrait")
  expect_equal(ret$output_type, "TXT")
  
})



test_that("create_report traps invalid parameters", {
  
  expect_error(create_report(orientation = "porait"))
  expect_error(create_report(output_type = "text"))
  
  
})


test_that("options_fixed sets default parameters appropriately", {
  
  ret <- create_report()
  
  ret <- options_fixed(ret)
  
  expect_equal(ret$cpuom, 12)
  
})


test_that("options_fixed changes parameters appropriately", {
  
  ret <- create_report()
  
  ret <- options_fixed(ret, cpuom = 10)
  
  expect_equal(ret$cpuom, 10)
  
})


test_that("options_fixed traps invalid parameters appropriately", {
  
  ret <- create_report()
  
  expect_error(options_fixed(ret, cpuom = 16))
  
  
})

test_that("Titles, footnotes, header, and footer limits work as expected.", {
    
  rpt <- create_report("fork.out")
  st <- rep("W", 50)
  
  expect_error(titles(rpt, st))
  expect_error(footnotes(rpt, st))
  expect_error(page_header(rpt, left=st))
  expect_error(page_footer(rpt, left=st))
  
  
})



test_that("Title/footnotes parameter checks work as expected.", {
  
  rpt <- create_report("fork.out")
  
  
  # Parameter checks
  expect_error(page_footer(rpt, "Hello", blank_row = "fork"))
  expect_error(titles(rpt, "Hello", blank_row = "fork"))
  expect_error(titles(rpt, "Hello", borders  = "fork"))
  expect_error(title_header(titles(rpt, "Hello"), "Hello"))
  expect_error(titles(title_header(rpt, "Hello"), "Hello"))
  expect_error(title_header(rpt, "Hello", blank_row = "fork"))
  expect_error(title_header(rpt, "Hello", borders = "fork"))
  expect_error(title_header(page_header(rpt, "Hello"), "Hello"))
  expect_error(page_header(title_header(rpt, "Hello"), "Hello"))
})


test_that("Footnotes traps invalid parameter as expected.", {
  
  rpt <- create_report("fork.out")
  
  expect_error(footnotes(rpt, align = "error"))
  # expect_error(footnotes(rpt, valign = "error"))
  expect_error(footnotes(rpt, blank_row = "error"))
  expect_error(footnotes(rpt, borders = "error"))
  
})

test_that("add_content works as expected.", {
  
  rpt <- create_report("fork.out")
  
  rpt <- add_content(rpt, "", page_break = FALSE)
  
  # Should put a page break token before the content
  expect_equal(length(rpt$content), 1)
  expect_equal(rpt$content[[1]]$page_break, FALSE)
  
  # Invalid value
  expect_error(add_content(rpt, "", page_break = "sam"))

})


test_that("create_report parameter checks work as expected.", {
  
  
  expect_error(create_report(units = "fork"))
  expect_error(create_report(output_type = "fork"))
  expect_error(create_report(orientation = "fork"))
  expect_error(create_report(paper_size = "fork"))
  
  
  rpt <- create_report()
  expect_error(write_report(rpt))
  
  expect_error(write_report("fork"))
  expect_error(write_report(NA))
  
})

test_that("line_size and line_count parameter checks work as expected.", {

  rpt <- create_report()
  expect_error(options_fixed(rpt, line_size = "a"))  
  expect_error(options_fixed(rpt, line_size = -35))
  expect_error(options_fixed(rpt, line_count = "a"))
  expect_error(options_fixed(rpt, line_count = -876))
})




test_that("options_fixed parameter checks work as expected.", {
  
  
  rpt <- create_report()
  
  expect_error(options_fixed(rpt, editor = "fork"))
  expect_error(options_fixed(rpt, cpuom = -2))
  expect_error(options_fixed(rpt, lpuom = 2356))
  
})


test_that("preview parameter checks work as expected.", {
  
  rpt <- create_report()
  
  expect_error(write_report(rpt, preview = - 1))
  expect_error(write_report(rpt, preview = "a"))
  
})


test_that("font parameter checks work as expected.", {
  
  expect_error(create_report(font = "fork"))
  expect_error(create_report(font_size = 14))
  
})


test_that("title_header function works as expected.", {
  
  tbl <- create_table(mtcars)
  
  th <- tbl %>% title_header("Table 1.0", "MTCARS Sample Data",
                             right = c("One", "Two"), blank_row = "below")
  
  expect_equal(is.null(th$title_hdr[[1]]), FALSE)
  expect_equal(length(th$title_hdr[[1]]$titles), 2)
  expect_equal(length(th$title_hdr[[1]]$right), 2)
  expect_equal(th$title_hdr[[1]]$blank_row, "below")

  
})


test_that("page_by function works as expected.", {
  
  tbl <- create_table(mtcars)
  
  pg <- tbl %>% page_by(mpg, "MPG: ", "right", blank_row = "below")
  
  expect_equal(is.null(pg$page_by), FALSE)
  expect_equal(pg$page_by$var, "mpg")
  expect_equal(pg$page_by$label, "MPG: ")
  expect_equal(pg$page_by$align, "right")
  expect_equal(pg$page_by$blank_row, "below")
  
  pg <- tbl %>% page_by("mpg")
  
  expect_equal(is.null(pg$page_by), FALSE)
  expect_equal(pg$page_by$var, "mpg")
  expect_equal(is.null(pg$page_by$label), FALSE)
  expect_equal(pg$page_by$label, "mpg: ")
  expect_equal(pg$page_by$align, "left")
  expect_equal(pg$page_by$blank_row, "below")
  
  # Parameter checks
  expect_error(page_by(tbl, align = "fork"))
  expect_error(page_by(tbl, blank_row = "fork"))
  expect_error(page_by(tbl, borders = "fork"))
  expect_error(page_by(tbl, bold = "fork"))
})

test_that("Width parameter on titles and footnotes works as expected.", {
  
  tbl <- create_table(mtcars)
  
  th <- title_header(tbl, "Table 1.0", right = c("One", "Two"), 
                             width = "content")
  
  expect_equal(th$title_hdr[[1]]$width, "content")
  expect_error( title_header(tbl, "Table 1.0", right = c("One", "Two"), 
                             width = "bork"))
  
  tbl2 <- create_table(mtcars)
  ttl <- titles(tbl2, "Table 1.0", 
                     width = "page") 
  
  expect_equal(ttl$titles[[1]]$width, "page")
  expect_error( titles(tbl2, "Table 1.0", width = as.Date("2021-09-16")))
  
  ftnt <- footnotes(tbl2, "Table 1.0", 
                width = 6)
  
  expect_equal(ftnt$footnotes[[1]]$width, 6)
  expect_error( footnotes(tbl2, "Table 1.0", width = "fork"))
  
  tbl3 <- create_table(mtcars)
  ttl <- titles(tbl3, "Table 1.0") 
  
  expect_equal(ttl$titles[[1]]$width, "content")

})

test_that("output_type parameter checks work as expected.", {
  
  res <- create_report(output_type = "TXT")
  expect_equal(res$output_type, "TXT")
  
  res <- create_report(output_type = "PDF")
  expect_equal(res$output_type, "PDF")
  
  res <- create_report(output_type = "RTF")
  expect_equal(res$output_type, "RTF")
  
  res <- create_report(output_type = "HTML")
  expect_equal(res$output_type, "HTML")
  

})

test_that("report_options works as expected.", {
  
  res <- create_report(output_type = "rtf") |>
    report_options(allow_code = T, line_break = F, line_count = 18,
                   page_wrap = F, auto_page = F, title_block = "paragraph",
                   line_height = 0.01)
  
  expect_equal(res$allow_code, T)  
  expect_equal(res$line_break, F)
  expect_equal(res$user_line_count, 18)
  expect_equal(res$page_wrap, F)
  expect_equal(res$auto_page, F)
  expect_equal(res$title_block, "paragraph")
  expect_equal(res$user_line_height, 0.01)
})

test_that("report_options traps invalid parameters as expected.", {
  
  expect_error(res <- create_report(output_type = "rtf") |>
                  report_options(allow_code = "TRUE"), 
                "`allow_code` should be TRUE or FALSE.")  
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(line_break = "TRUE"), 
               "`line_break` should be TRUE or FALSE.")  
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(page_wrap = "TRUE"), 
               "`page_wrap` should be TRUE or FALSE.") 
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(title_block = "para"), 
               "`title_block` should be 'table' or 'paragraph'.") 
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(line_count = "1"), 
               "line_count must be a number.") 
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(line_count = 0), 
               "line_count must be greater than zero.") 
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(line_height = "1"), 
               "`line_height` should be a numeric value.") 
  
  expect_error(res <- create_report(output_type = "rtf") |>
                 report_options(line_height = 0), 
               "`line_height` should be greater than 0.")
  
  res <- create_report(output_type = "docx") |>
    report_options(allow_code = T)
  
  expect_false(res$allow_code)
})

test_that("footer_image works as expected.", {
  
  res <- create_report(output_type = "rtf") |>
    footer_image("./image1.jpg", height = "1", width = "1", align = "left") |>
    footer_image("./image2.jpg", height = "2", width = "2", align = "center") |>
    footer_image("./image3.jpg", height = "3", width = "3", align = "right")
  
  expect_equal(res$footer_image_left, 
               list("image_path" = "./image1.jpg", "height" = "1", "width" = "1", "align" = "left"))
  expect_equal(res$footer_image_center, 
               list("image_path" = "./image2.jpg", "height" = "2", "width" = "2", "align" = "center"))
  expect_equal(res$footer_image_right, 
               list("image_path" = "./image3.jpg", "height" = "3", "width" = "3", "align" = "right"))
  
  expect_error(footer_image(res, image_path=1), "image_path object must an image file path.")
  expect_error(footer_image(res, image_path="", align = "top"), 
               "align must be left, right, center, or centre.")
})

test_that("header_image works as expected.", {
  
  res <- create_report(output_type = "rtf") |>
    header_image("./image1.jpg", height = "1", width = "1", align = "left") |>
    header_image("./image2.jpg", height = "2", width = "2", align = "center") |>
    header_image("./image3.jpg", height = "3", width = "3", align = "right")
  
  expect_equal(res$header_image_left, 
               list("image_path" = "./image1.jpg", "height" = "1", "width" = "1", "align" = "left"))
  expect_equal(res$header_image_center, 
               list("image_path" = "./image2.jpg", "height" = "2", "width" = "2", "align" = "center"))
  expect_equal(res$header_image_right, 
               list("image_path" = "./image3.jpg", "height" = "3", "width" = "3", "align" = "right"))
  
  expect_error(header_image(res, image_path=1), "image_path object must an image file path.")
  expect_error(header_image(res, image_path="", align = "top"), 
               "align must be left, right, center, or centre.")
})

test_that("print.report_spec works as expected.", {
  base_path <- tempdir()
  fp <- file.path(base_path, "test.rtf")
  
  dat <- iris
  
  tbl <- create_table(dat, borders = "none") %>%
    titles("Table 1.0", "My Nice Report with a Page By", borders = "none") %>%
    page_by(Species, label = "Species: ", align = "right", borders = "none")
  
  rpt <- create_report(fp, output_type = "RTF", font = "Arial",
                       font_size = 9, orientation = "landscape") %>%
    set_margins(top = 1, bottom = 1) %>%
    add_content(tbl) %>%
    page_header("Left", "Right") %>%
    page_footer("Left1", "Center1", "Right1") %>%
    footnotes("My footnote 1", "My footnote 2", borders = "none")
  
  res <- write_report(rpt, preview = 3)
  
  print.report_spec(res)
  
  expect_equal(class(res), c("report_spec", "list"))
})
