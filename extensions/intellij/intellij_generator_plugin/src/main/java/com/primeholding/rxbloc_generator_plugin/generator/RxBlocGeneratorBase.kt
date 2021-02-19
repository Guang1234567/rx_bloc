package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.fleshgrinder.extensions.kotlin.*
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxBlocGeneratorBase(private val name: String,
                                   withDefaultStates: Boolean,
                                   templateName: String, withExtension: Boolean = false) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
                TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
                TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dolarPascalCase(),
                TEMPLATE_BLOC_SNAKE_CASE to snakeCase()
        )
        try {
            /*
            var templateFolder = "rx_bloc"
            if (withDefaultStates && withExtensionFile) {
                templateFolder = "rx_bloc_with_default_states_with_and_extension"
            } else if (!withDefaultStates && withExtensionFile) {
                templateFolder = "rx_bloc_with_extension"
            } else if (withDefaultStates && !withExtensionFile) {
                templateFolder = "rx_bloc_with_default_states_with"
            }
             */
            val templateFolder = if (withDefaultStates) "rx_bloc_with_default_states" else "rx_bloc"
            val resource = "/templates/$templateFolder/$templateName.dart.template"
            val resourceAsStream = RxBlocGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    abstract fun fileName(): String

    fun generate(): String {
        val substitutor = StrSubstitutor(templateValues)
        return substitutor.replace(templateString)
    }

    fun dolarPascalCase(): String = "$" + pascalCase()
    fun pascalCase(): String = name.toUpperCamelCase().replace("Bloc", "")

    fun snakeCase() = name.toLowerSnakeCase().replace("_bloc", "")

    fun fileExtension() = "dart"
}