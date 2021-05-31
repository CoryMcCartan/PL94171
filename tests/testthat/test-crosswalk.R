test_that("crosswalks are formatted correctly", {
    cross = pl_crosswalk("RI", 2010, 2020)
    expect_equal(names(cross), c("GEOID", "GEOID_to", "area_land", "area_water", "int_land"))
    expect_gte(min(cross$int_land), 0)
    expect_lte(max(cross$int_land), 1)
})

test_that("crosswalks are reaggregated correctly", {
    test_d = expand.grid(row=1:4, col=1:4) %>%
        dplyr::as_tibble() %>%
        mutate(GEOID_from = case_when(row == 1 ~ "A",
                                      col == 1 ~ "B",
                                      row == 2 ~ "C",
                                      row == 4 ~ "D",
                                      TRUE ~ str_c(row, col)),
               GEOID_to = case_when(col == 1 ~ "A",
                                    row == 1 ~ "B",
                                    row == 3 ~ "C",
                                    row == 4 ~ "D",
                                    TRUE ~ str_c(row, col)),
               pop = row) %>%
        group_by(GEOID_from) %>%
        mutate(area_from = n(),
               pop_from = sum(pop))  %>%
        group_by(GEOID_to) %>%
        mutate(area_to = n(),
               pop_to = sum(pop))  %>%
        group_by(GEOID_from, GEOID_to) %>%
        summarize(pop_from = pop_from[1],
                  pop_to = pop_to[1],
                  int_land = n() / area_from[1],
                  area_land = as.double(area_to[1]),
                  area_water = 0.0) %>%
        ungroup()

    pop_d_from = select(test_d, GEOID=GEOID_from, pop=pop_from) %>%
        dplyr::distinct()
    pop_d_to = select(test_d, GEOID=GEOID_to, area_land, area_water, pop=pop_to) %>%
        dplyr::distinct()
    crosswalk = select(test_d, GEOID=GEOID_from, GEOID_to,
                       int_land, area_land, area_water)

    expect_equal(arrange(pl_retally(pop_d_from, crosswalk), GEOID),
                 arrange(pop_d_to, GEOID))
})
