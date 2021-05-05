package com.example.reddot.rest

import io.micronaut.context.annotation.Value
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get

@Controller
class RedDotApi {
    @Value("\${reddot.appname}")
    var appname: String = "dev"

    @Get("/")
    fun awardWinning(): String {
        return "Almost Award getting application at stage: ${appname}"
    }
}