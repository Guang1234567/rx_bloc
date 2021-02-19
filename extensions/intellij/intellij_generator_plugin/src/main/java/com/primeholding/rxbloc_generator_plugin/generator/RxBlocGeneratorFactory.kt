package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedBlocGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxExtensionFileGenerator

object RxBlocGeneratorFactory {
    fun getBlocGenerators(name: String, useEquatable: Boolean, addExtension: Boolean): List<RxBlocGeneratorBase> {
        val bloc = RxBlocGenerator(name, useEquatable)
        val generatedBloc = RxGeneratedBlocGenerator(name, useEquatable)
//        val extensionGenerator = RxExtensionFileGenerator(name, useEquatable)
        return listOf(bloc, generatedBloc)
    }
}