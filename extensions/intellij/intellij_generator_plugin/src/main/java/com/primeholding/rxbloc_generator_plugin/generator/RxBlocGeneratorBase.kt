package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.fleshgrinder.extensions.kotlin.*
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxBlocGeneratorBase(private val name: String,
                                   withDefaultStates: Boolean,
                                   includeExtensions: Boolean,
                                   includeNullSafety: Boolean,
                                   templateName: String) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dollarPascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase()
        )
        try {
            val templateFolder = StringBuilder()
            if(withDefaultStates && !includeExtensions) {
                templateFolder.append("rx_bloc_with_default_states")
            } else if(withDefaultStates && includeExtensions) {
                templateFolder.append("rx_bloc_with_extensions_with_default_states")
            } else if (!withDefaultStates && includeExtensions) {
                templateFolder.append("rx_bloc_with_extensions")
            } else {
                templateFolder.append("rx_bloc")
            }

            val resource = "/templates/${templateFolder}/$templateName.dart.template"
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

    private fun dollarPascalCase(): String = "$" + pascalCase()
    private fun pascalCase(): String = name.toUpperCamelCase().replace("Bloc", "")

    fun snakeCase() = name.toLowerSnakeCase().replace("_bloc", "")
    fun fileExtension() = "dart"
}