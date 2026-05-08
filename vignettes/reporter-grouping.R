## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# library(reporter)
# 
# # Create temp file name
# tmp <- file.path(tempdir(), "example16a.pdf")
# 
# # Create data
# arm <- c(rep("A", 3), rep("B", 2), rep("C", 3), rep("D", 2))
# subjid <- 100:109
# name <- c("Quintana, Gabriel", "Allison, Blas", "Minniear, Presley",
#           "al-Kazemi, Najwa \nand more and more", "Schaffer, Ashley", "Laner, Tahma",
#           "Perry, Sean", "Crews, Deshawn Joseph", "Person, Ladon",
#           "Smith, Shaileigh")
# sex <- c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M")
# age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
# 
# df <- data.frame(arm, subjid, name, sex, age, stringsAsFactors = FALSE)
# df <- rbind(df, df, df, df)
# 
# # Output with group_border
# tbl1 <- create_table(df, first_row_blank = FALSE, borders = "outside") %>%
#   define(subjid, label = "Subject ID for a patient", n = 10, align = "left",
#          width = 1) %>%
#   define(name, label = "Subject Name", width = 1) %>%
#   define(sex, label = "Sex", n = 10, align = "center") %>%
#   define(age, label = "Age", n = 10) %>%
#   define(arm, label = "Arm",
#          dedupe = TRUE,
#          group_border = TRUE) %>%
#   footnotes("This is the footnote")
# 
# 
# rpt <- create_report(tmp, output_type = "pdf", font = "Arial",
#                      font_size = 10) %>%
#   titles(c("Table 1.0", "This is a table with group border"), align = "center") %>%
#   add_content(tbl1) %>%
#   footnotes(c("This is the footnote 1")) %>%
#   page_header(left = "Test header", right = "Test header") %>%
#   set_margins(top = 1, bottom = 1)
# 
# 
# res <- write_report(rpt)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
# library(reporter)
# 
# fp <- file.path(tempdir(), "example16b.pdf")
# 
# dat <- iris[1:91,]
# 
# dat$group_1 <- c(
#   rep("A", 14),
#   rep("B", 6),
#   rep("C", 22),
#   rep("D", 18),
#   rep("E", 31)
# )
# 
# dat$group_2 <- c(
#   rep("Flower A\nSubgroup A1", 14),
#   rep("Flower B\nSubgroup B1", 3),
#   rep("Flower B\nSubgroup B2", 3),
#   c(rep("Flower C1", 17)),
#   c(rep("Flower C2", 5)),
#   c(rep("Flower D", 16), rep("Flower D\nSubgroup D1", 2)),
#   c(rep("Flower E1", 2)),
#   c(rep("Flower E2", 29))
# )
# 
# dat <- dat[, c("group_1", "group_2", "Sepal.Length",
#                "Sepal.Width", "Petal.Length","Petal.Width")]
# 
# tbl <- create_table(dat, borders = "outside") %>%
#   define(group_1, group_cohesion = TRUE, label = "Group 1", blank_after = T) %>%
#   define(group_2, group_cohesion = TRUE, label = "Group 2")
# 
# rpt <- create_report(fp, output_type = "pdf", font = "Arial",
#                      font_size = 10, orientation = "landscape") %>%
#   titles("Table 1.0", "My Nice Report with Group Cohesion") %>%
#   set_margins(top = 1, bottom = 1) %>%
#   add_content(tbl) %>%
#   footnotes("My footnote 1", "My footnote 2", borders = "none",
#             blank_row = "none")
# 
# res <- write_report(rpt)

