import org.jetbrains.changelog.markdownToHTML

fun properties(key: String) = project.findProperty(key).toString()

plugins {
    // Java support
    id("java")
    // gradle-intellij-plugin - read more: https://github.com/JetBrains/gradle-intellij-plugin
    id("org.jetbrains.intellij") version "1.5.3"
    // gradle-changelog-plugin - read more: https://github.com/JetBrains/gradle-changelog-plugin
    id("org.jetbrains.changelog") version "1.3.1"
    // grammarkit - read more: https://github.com/JetBrains/gradle-grammar-kit-plugin
    id("org.jetbrains.grammarkit") version "2021.2.2"
}

group = properties("pluginGroup")
version = properties("pluginVersion")

// Set the compatibility versions to 1.11
java {
    sourceCompatibility = JavaVersion.VERSION_11
}

// Configure project's dependencies
repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.7.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testRuntimeOnly("org.junit.vintage:junit-vintage-engine")
}

// Configure gradle-intellij-plugin plugin.
// Read more: https://github.com/JetBrains/gradle-intellij-plugin
intellij {
    pluginName.set(properties("pluginName"))
    version.set(properties("platformVersion"))
    type.set(properties("platformType"))
    updateSinceUntilBuild.set(true)
}

changelog {
    headerParserRegex.set("^[-._+0-9a-zA-Z]+\$")
}

grammarKit {
    // version of IntelliJ patched JFlex (see bintray link below), Default is 1.7.0-1
    jflexRelease.set("1.7.0-1")

    // tag or short commit hash of Grammar-Kit to use (see link below). Default is 2020.1.2
    grammarKitRelease.set("2021.1.2")
}

sourceSets {
    main {
        java {
            srcDir("src/gen/java")
            srcDir("src/main/java")
        }
    }
}

tasks {
    task("metadata") {
        outputs.upToDateWhen { false }
        doLast {
            val dir = project.buildDir.resolve("metadata")
            dir.mkdirs()
            dir.resolve("version.txt").writeText(properties("pluginVersion"))
            dir.resolve("zipfile.txt").writeText(buildPlugin.get().archiveFile.get().toString())
            dir.resolve("latest_changelog.md").writeText(changelog.getLatest().toText())
            dir.resolve("pluginVerifierIdeVersions.txt").writeText(properties("pluginVerifierIdeVersions"))
        }
    }

    generateLexer {
        source.set("src/main/lang/Nix.flex")
        targetDir.set("src/gen/java/org/nixos/idea/lang")
        targetClass.set("_NixLexer")
        purgeOldFiles.set(true)
    }

    generateParser {
        source.set("src/main/lang/Nix.bnf")
        targetRoot.set("src/gen/java")
        pathToParser.set("/org/nixos/idea/lang/NixParser")
        pathToPsiRoot.set("/org/nixos/idea/psi")
        purgeOldFiles.set(true)
    }

    compileJava {
        dependsOn(generateLexer, generateParser)
    }

    test {
        useJUnitPlatform()
    }

    patchPluginXml {
        version.set(properties("pluginVersion"))
        sinceBuild.set(properties("pluginSinceBuild"))
        untilBuild.set(properties("pluginUntilBuild"))

        // Extract the <!-- Plugin description --> section from README.md and provide for the plugin's manifest
        pluginDescription.set(provider {
            File("./README.md").readText().lines().run {
                val start = "<!-- Plugin description -->"
                val end = "<!-- Plugin description end -->"

                if (!containsAll(listOf(start, end))) {
                    throw GradleException("Plugin description section not found in README.md file:\n$start ... $end")
                }
                subList(indexOf(start) + 1, indexOf(end))
            }.joinToString("\n").run { markdownToHTML(this) }
        })

        // Get the latest available change notes from the changelog file
        changeNotes.set(provider { changelog.getLatest().toHTML() })
    }

    runPluginVerifier {
        ideVersions.set(properties("pluginVerifierIdeVersions").split(","))
        failureLevel.set(org.jetbrains.intellij.tasks.RunPluginVerifierTask.FailureLevel.ALL)
    }

    publishPlugin {
        token.set(System.getenv("JETBRAINS_TOKEN"))
        channels.set(listOf(properties("pluginVersion").split('-').getOrElse(1) { "default" }.split('.').first()))
    }
}
