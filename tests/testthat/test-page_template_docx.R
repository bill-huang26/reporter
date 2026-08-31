context("Page Template DOCX Tests")



test_that("get_titles_docx function works as expected.", {


  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 12) %>%
    titles("Hello", "here is \n something", blank_row = "below") %>%
    footnotes("Goodbye", blank_row = "below")

  rpt <- page_setup_docx(rpt)

  t <- get_titles_docx(rpt$titles, 6, rpt)
  t
  expect_equal(length(t$docx), 1)
  expect_equal(t$lines, 4)

})

test_that("get_titles_docx function works as expected with font_size.", {
  
  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 9) %>%
    titles("a a a a a a a a a",
           width = 1)
  
  rpt <- page_setup_docx(rpt)
  
  t9 <- get_titles_docx(rpt$titles, 1, rpt)
  expect_equal(length(t9$docx), 1)
  expect_equal(t9$lines, 2)
  
  # Lines_content returns corrent lines in content size
  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 9) %>%
    titles("a a a a a a a a a",
           width = 1, font_size = 14)
  
  rpt <- page_setup_docx(rpt)
  
  t14 <- get_titles_docx(rpt$titles, 1, rpt)
  expect_equal(length(t14$docx), 1)
  expect_equal(t14$lines, 3)
  expect_equal(t14$lines_content, 5)
  
})


test_that("get_footnotes_docx function works as expected.", {


  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 12) %>%
    titles("Hello", blank_row = "below") %>%
    footnotes("Goodbye", blank_row = "below")

  rpt <- page_setup_docx(rpt)

  f <- get_footnotes_docx(rpt$footnotes, 6, rpt)
  f
  expect_equal(length(f$docx), 1)
  expect_equal(f$lines, 2)

})

test_that("get_footnotes_docx function works as expected with font_size.", {
  
  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 12) %>%
    footnotes("a a a a a a a a a",
              width = 1)
  
  rpt <- page_setup_docx(rpt)
  
  f12 <- get_footnotes_docx(rpt$footnotes, 1, rpt)
  expect_equal(length(f12$docx), 1)
  expect_equal(f12$lines, 3)
  
  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 12) %>%
    footnotes("a a a a a a a a a",
              width = 1, font_size = 8)
  
  rpt <- page_setup_docx(rpt)
  
  f8 <- get_footnotes_docx(rpt$footnotes, 1, rpt)
  expect_equal(length(f8$docx), 1)
  expect_equal(f8$lines, 2)
  
  # Lines_content returns corrent lines in content size
  rpt <- create_report("", output_type = "DOCX", font = "Arial",
                       font_size = 8) %>%
    footnotes("a a a a a a a a a",
              width = 1, font_size = 12)
  
  rpt <- page_setup_docx(rpt)
  
  f12_8 <- get_footnotes_docx(rpt$footnotes, 1, rpt)
  expect_equal(length(f12_8$docx), 1)
  expect_equal(f12_8$lines, 3)
  expect_equal(f12_8$lines_content, 5)
})




test_that("get_title_header_docx function works as expected.", {

  rpt2 <- create_report("", output_type = "DOCX", font = "Arial", 
                        font_size = 12) %>%
    title_header("Hello", right = paste("Right here is something",
    "really long that will wrap and wrap and wrap and wrap keep wrapping"))

  rpt2 <- page_setup_docx(rpt2)

  th <- get_title_header_docx(rpt2$title_hdr, 6, rpt2)
  th
  expect_equal(nchar(th$docx) > 1, TRUE)
  expect_equal(th$lines, 4)

})

 
test_that("get_page_header_docx works as expected.", {

  rpt3 <- create_report("", output_type = "DOCX", font = "Arial", 
                        font_size = 12) %>%
    page_header(left= c("Left"), right = "Right") %>%
                # right = paste("Right here is something that might wrap.",
                #               "If it is long enough so let's make it longer",
                #               "If it is long enough so let's make it longer",
                #               "If it is long enough so let's make it longer")
                # ) %>%
    page_footer("Left", "Center", "Right here is something")

  rpt3 <- page_setup_docx(rpt3)

  ph <- get_page_header_docx(rpt3)
  ph

  expect_equal(ph$lines, 1)

  # Output error as expected
  image_path <- "data/logo.jpg"
  
  rpt4 <- create_report("", font = "Arial", font_size = 12) %>%
    header_image(image_path, height = 0.5, width = 0.8, align = "left")
  
  expect_error(
    ret <- get_page_header_docx(rpt4),
    "`page_header` must be used when using `header_image`."
  )
  
  rpt4 <- create_report("", font = "Arial", font_size = 12) %>%
    header_image(image_path, height = 0.5, width = 4, align = "left") %>%
    header_image(image_path, height = 0.5, width = 4, align = "center") %>%
    header_image(image_path, height = 0.5, width = 4, align = "right") %>%
    page_header(width = c(4,4,4))
  
  expect_error(
    ret <-  page_setup_docx(rpt4),
    "Total width of page header 12 inches cannot be greater than content width 9 inches."
  )
  
  # Image
  image_path <- "data/logo.jpg"
  
  rpt5 <- create_report("", font = "Arial", font_size = 12) %>%
    header_image(image_path, height = 0.5, width = 0.8, align = "left") %>%
    header_image(image_path, height = 0.5, width = 0.8, align = "center") %>%
    header_image(image_path, height = 0.5, width = 0.8, align = "right") %>%
    page_header()
  
  ret <-  page_setup_docx(rpt5)
  
  expect_equal(ret$page_template$page_header$image_path, c("data/logo.jpg", "data/logo.jpg", "data/logo.jpg"))
  expect_equal(ret$page_template$page_header$lines, 3)
})

 
test_that("get_page_footer_docx works as expected.", {

  rpt3 <- create_report("", font = "Arial", font_size = 12) %>%
    page_header(left= c("Hello"),
                right = paste("Right here is something that might wrap.",
                              "If it is long enough so let's make it longer",
                              "If it is long enough so let's make it longer",
                              "If it is long enough so let's make it longer")) %>%
    page_footer("Left", "Center", "Right here is something")

  rpt3 <- page_setup_docx(rpt3)

  pf <- get_page_footer_docx(rpt3)
  pf

  expect_equal(pf$lines, 1)

  # Output error as expected
  image_path <- "data/logo.jpg"
  
  rpt4 <- create_report("", font = "Arial", font_size = 12) %>%
    footer_image(image_path, height = 0.5, width = 0.8, align = "left")
  
  expect_error(
    ret <- get_page_footer_docx(rpt4),
    "`page_footer` must be used when using `footer_image`."
  )
  
  rpt4 <- create_report("", font = "Arial", font_size = 12) %>%
    footer_image(image_path, height = 0.5, width = 4, align = "left") %>%
    footer_image(image_path, height = 0.5, width = 4, align = "center") %>%
    footer_image(image_path, height = 0.5, width = 4, align = "right") %>%
    page_footer(width = c(4,4,4))
  
  expect_error(
    ret <-  page_setup_docx(rpt4),
    "Total width of page footer 12 inches cannot be greater than content width 9 inches."
  )
  
  # Image
  image_path <- "data/logo.jpg"
  
  rpt5 <- create_report("", font = "Simsun", font_size = 12) %>%
    footer_image(image_path, height = 0.5, width = 0.8, align = "left") %>%
    footer_image(image_path, height = 0.5, width = 0.8, align = "center") %>%
    footer_image(image_path, height = 0.5, width = 0.8, align = "right") %>%
    page_footer()
  
  ret <-  page_setup_docx(rpt5)
  
  expect_equal(ret$page_template$page_footer$image_path, c("data/logo.jpg", "data/logo.jpg", "data/logo.jpg"))
  expect_equal(ret$page_template$page_footer$lines, 3)
})



test_that("get_pageby_docx works as expected.", {

  tbl <- create_table(mtcars) %>%
    page_by(cyl, "Cylinders:")

  rpt <- create_report("", font = "Arial", font_size = 12) %>%
    titles("Hello") %>%
    footnotes("Goodbye") %>%
    add_content(tbl)

  rpt <- page_setup_docx(rpt)

  rpt$line_height

  res <- get_page_by_docx(tbl$page_by, 6, "fork", rpt, "left")
  res

  expect_equal(res$lines, 2)
})


# test_that("get_cell_borders_docx works as expected.", {
#   
#   expect_equal(get_cell_borders_html(1, 1, 1, 1, c("all")),
#       paste0("border-top:thin solid;border-bottom:thin solid;",
#              "border-left:thin solid;border-right:thin solid;"))
#   
#   expect_equal(get_cell_borders_html(1, 1, 1, 1, c("all"), exclude = "bottom"),
#                paste0("border-top:thin solid;",
#                       "border-left:thin solid;border-right:thin solid;"))
#   
# })
