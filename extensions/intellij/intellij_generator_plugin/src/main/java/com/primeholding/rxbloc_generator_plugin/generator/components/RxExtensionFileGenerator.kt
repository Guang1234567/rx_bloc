package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxExtensionFileGenerator(
        blocName: String,
        blocShouldUseEquatable: Boolean
) : RxBlocGeneratorBase(blocName, blocShouldUseEquatable, templateName = "rx_bloc_extension") {

    override fun fileName() = "${snakeCase()}_extension.${fileExtension()}"
}
