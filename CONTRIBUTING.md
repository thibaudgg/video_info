Contributing
--------

The guidelines for contributions are as follows:
* Make sure you include comprehensive specs for new features and bug-fixes
* Make sure all of the specs pass by running `rspec` in the root project directory. Pull requests with failing tests will not be merged.
* Make sure there are no style issues by running `rubocop` in the root project directory. Pull requests with style issues will not be merged
* Optimally, you should create a separate branch to make rebasing with `master` simpler if other work gets merged in before your patch does.
* In bug reports, post the outputs of `VideoInfo::VERSION` and `ruby --version`
* In bug reports, provide detailed and clear reproduction steps. Optimally, provide some sample code.
* In bug reports, try to test against the `master` branch. If the bug does not exist in `master`, it is most likely known and a fix will be in the next release.
