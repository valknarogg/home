// Manually run the following:
// gem install sass
// gem update --system
// gem install scss-lint

module.exports = function (grunt) {
  'use strict';
  // Project configuration
  grunt.initConfig({
    // Metadata
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= props.license %> */\n',

    webfont: {
      icons: {
        src: [
          'icons/sbed/*.svg',
          'icons/lorc/*.svg'
        ],
        dest: 'fonts',
        options: {
          styles: 'font,icon,extra',
          fontFilename: 'game-icons',
          types: ['eot', 'woff2', 'woff', 'ttf', 'svg'],
          syntax: 'bootstrap',
          destCss: 'css',
          destScss: 'scss',
          templateOptions: {
            baseClass: 'gi',
            classPrefix: 'gi-'
          },
          fontFamilyName: 'GameIcons',
          font: 'game-icons',
          stylesheets: ['css', 'scss'],
          fontPathVariables: true,
          htmlDemo: false,
        }
      }
    },
    // CSS Min
    // =======
    cssmin: {
      target: {
        files: {
          'css/game-icons.min.css': 'css/game-icons.css'
        }
      }
    }
  });

  // These plugins provide necessary tasks
  grunt.loadNpmTasks('grunt-webfont');
  grunt.loadNpmTasks('grunt-contrib-cssmin');

  grunt.registerTask('default', [
    'webfont',
    'cssmin'
  ]);
};
