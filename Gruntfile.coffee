module.exports = ( grunt ) ->
  srcs = [
    'brower'
  ]

  deps = [
  ]


  # Coverage thresholds
  thresholds =
    lines: 60
    statements: 50
    branches: 40
    functions: 50

  # This functions makes the config shorter and clearer later on.
  # It just returns the type specific coverage config
  coverage = ( type, optionsRef ) ->
    optionsRef.template = require('grunt-template-jasmine-istanbul')
    optionsRef.templateOptions =
      coverage: 'stat/coverage/coverage.json'
      # thresholds: thresholds
      report:
        type: type
        options:
          dir: "stat/coverage/#{type}"

    return optionsRef

  # Configure all the tasks!

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      src:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: 'src'
          src: srcs.map ( src ) -> src + '.coffee'
          dest: 'dist'
          ext: '.js'
        ]

      spec:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: 'spec'
          src: ['**/*.coffee']
          dest: 'build/spec'
          ext: '.js'
        ]

      perf:
        files: [
          expand: true
          cwd: 'perf'
          src: ['**/*.coffee']
          dest: 'build/perf'
          ext: '.js'
        ]

    browserify:
      default:
        files: 'dist/brower.browser.js': 'dist/brower.js'
        options:
          sourceMap: false
          browserifyOptions:
            standalone: 'Brower'
      istanbul:
        files: 'build/spec/brower.browser.js': 'dist/brower.js'
        options:
          sourceMap: true
          transform: [require('browserify-istanbul')]
          browserifyOptions:
            standalone: 'Brower'

    uglify:
      default:
        files: 'dist/brower.browser.min.js': 'dist/brower.browser.js'
      bundle:
        files: 'dist/brower.bundle.min.js': 'dist/brower.bundle.js'

    concat:
      bundle:
        files:
          'dist/brower.bundle.js': deps.concat('dist/brower.browser.js')

    jasmine:
      default:
        src:  ['dist/brower.browser.js']
        options:
          vendor: deps
          keepRunner: true
          specs: 'build/spec/**/*.js'
      lcovonly:
        src:  ['build/spec/brower.browser.js']
        options: (coverage 'lcovonly',
          vendor: deps
          keepRunner: true
          specs: 'build/spec/**/*.js'
        )
      html:
        src: ['build/spec/brower.browser.js']
        options: (coverage 'html',
          vendor: deps
          specs: 'build/spec/**/*.js'
        )

    benchmark:
      default:
        src: ['build/perf/**/*.js']
        dest: 'stat/perf/result.csv'

    clean:
      build: ['build']

    watch:
      default:
        files: ['src/**/*.coffee', 'spec/**/*.coffee']
        tasks: ['spec']

    codo:
      files: ['src/**/*.coffee']

  # grunt.loadNpmTasks 'grunt-babel'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-benchmark'
  grunt.loadNpmTasks 'grunt-codo'

  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'dist',    ['coffee:src', 'browserify:default', 'concat:bundle', 'uglify']
  grunt.registerTask 'spec',    ['clean', 'dist', 'coffee:spec' ,'jasmine:default']
  grunt.registerTask 'perf',    ['clean', 'dist', 'coffee:perf' ,'benchmark:default']
  grunt.registerTask 'test',    ['spec', 'browserify:istanbul', 'jasmine:lcovonly']
  grunt.registerTask 'cov',     ['spec', 'browserify:istanbul', 'jasmine:html']

# module.exports = ( grunt ) ->
#   srcs = [
#     'src/brower.coffee'

#     'src/abstract_view.coffee'
#     'src/expandable_view.coffee'

#     'src/null_view.coffee'
#     'src/undefined_view.coffee'
#     'src/string_view.coffee'
#     'src/enumerable_view.coffee'
#     'src/function_view.coffee'
#     'src/boolean_view.coffee'

#     'src/number_view.coffee'
#     'src/root_view.coffee'

#     'src/utils/rivets_brower.coffee'

#     'src/export.coffee'
#   ]

#   vendor = [
#     "bower_components/sightglass/index.js"
#     "bower_components/rivets/dist/rivets.js"
#     "bower_components/es6-shim/es6-shim.js"
#     "bower_components/absurd/client-side/build/absurd.js"
#   ]


#   specs = [
#     '.grunt/brower/spec_compiled/brower.js'
#     '.grunt/brower/spec_compiled/export.js'
#   ]

#   grunt.initConfig
#     pkg: grunt.file.readJSON('package.json')

#     coffee:
#       dist:
#         options:
#           join: true
#         files:
#           'dist/brower.js': srcs

#       build:
#         options:
#           join: true
#           sourceMap: true
#         files:
#           'build/brower.js': srcs

#       spec:
#         files: [
#           expand: true
#           cwd: 'spec'
#           src: ['**/*.coffee']
#           dest: '.grunt/brower/spec_compiled'
#           ext: '.js'
#         ]

#     jasmine:
#       build:
#         src: ['build/**/*.js']
#         options:
#           specs: specs
#           vendor: vendor
#           keepRunner: true

#     clean:
#       build: ['build']
#       spec:  ['.grunt/brower/spec_compiled']
#       grunt: ['.grunt']

#     watch:
#       all:
#         files: ['src/**/*.coffee']
#         tasks: ['coffee:build', 'coffee:spec']

#   grunt.loadNpmTasks 'grunt-contrib-coffee'
#   grunt.loadNpmTasks 'grunt-contrib-watch'
#   grunt.loadNpmTasks 'grunt-contrib-clean'
#   grunt.loadNpmTasks 'grunt-contrib-jasmine'

#   grunt.registerTask 'default', ['coffee','jasmine:build', 'watch']
#   grunt.registerTask 'build',   ['coffee:build']
#   grunt.registerTask 'dist',    ['coffee:dist']
#   grunt.registerTask 'spec',    ['clean:spec', 'coffee:build', 'coffee:spec', 'jasmine:build', 'clean:spec']



# # module.exports = ( grunt ) ->
# #   srcs = [
# #     'src/list.coffee'
# #   ]

# #   grunt.initConfig
# #     pkg: grunt.file.readJSON('package.json')

# #     meta:
# #       banner:
# #         '// Collection\n' +
# #         '// version: <%= pkg.version %>\n' +
# #         '// contributors: <%= pkg.contributors %>\n' +
# #         '// license: <%= pkg.licenses[0].type %>\n'

# #     coffee:
# #       dist:
# #         options:
# #           join: true
# #         files:
# #           'dist/list.js': 'src/list.coffee'

# #       build:
# #         options:
# #           join: true
# #           sourceMap: true
# #         files:
# #           'build/list.js': 'src/list.coffee'

# #       spec:
# #         files: [
# #           expand: true
# #           cwd: 'spec'
# #           src: ['**/*.coffee']
# #           dest: '.grunt/list/spec_compiled'
# #           ext: '.js'
# #         ]

# #     jasmine:
# #       build:
# #         src: ['build/list.js']
# #         options:
# #           specs: '.grunt/list/spec_compiled/**/*.js'
# #           vendor: []
# #           template: require('grunt-template-jasmine-istanbul')
# #           templateOptions:
# #             coverage: 'statistics/coverage/coverage.json'
# #             report:
# #               type: 'lcovonly'
# #               options:
# #                 dir: '.grunt/list/coverage/lcov'
# #             thresholds:
# #               lines: 60
# #               statements: 60
# #               branches: 60
# #               functions: 60
# #       html:
# #         src: ['build/list.js']
# #         options:
# #           specs: '.grunt/list/spec_compiled/**/*.js'
# #           vendor: []
# #           template: require('grunt-template-jasmine-istanbul')
# #           templateOptions:
# #             coverage: 'statistics/coverage/coverage.json'
# #             report:
# #               type: 'html'
# #               options:
# #                 dir: 'statistics/coverage/html'
# #             thresholds:
# #               lines: 60
# #               statements: 60
# #               branches: 60
# #               functions: 60

# #     plato:
# #       all:
# #         options:
# #           jshint: false
# #         files:
# #           'statistics/complexity' : ['.grunt/list/src_compiled/**/*.js']


# #     clean:
# #       build: ['build']
# #       spec:  ['.grunt/list/spec_compiled']
# #       grunt: ['.grunt']

# #     watch:
# #       all:
# #         files: 'src/**/*.coffee'
# #         tasks: ['build', 'spec']

# #   grunt.registerTask 'watch',   ['coffee:build', 'watch']
# #   grunt.registerTask 'spec',    ['clean:spec', 'coffee:build', 'coffee:spec', 'jasmine:build', 'clean:spec']
# #   grunt.registerTask 'build',   ['coffee:build']
# #   grunt.registerTask 'dist',    ['coffee:dist']
# #   grunt.registerTask 'analyze', ['coffee','jasmine:html', 'plato']
