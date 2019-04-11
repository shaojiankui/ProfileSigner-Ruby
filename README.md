
# 配置:
### 0.使用breww或者rvm安装ruby,macos自带ruby不好用.我安的是2.6.0.  2.4.0 Gemfile中不用解开openssl注释,因为2.6.0.  2.4.0中自带openssl模块

### 1.bundler初始化项目
gem install bundler
or
sudo gem install bundler

bundle install --path vendor/bundle

####  plist库有问题,所以我手动改了下.
 `require': /Users/jakey/Desktop/ios-profile-service/plist/lib/plist/binary.rb:161: invalid multibyte escape: /[\x80-\xff]/

####  ProfileSigner.rb 配置
ssl_cert.pem,ssl_private.pem 需要替换成自己的证书,unsignedProfile.mobileconfig替换成未签名的profile文件

ProfileSigner.rb 的gen方法,可以选择是签名现有profile文件 还是自动生成profile文件,默认是读取已经存在的配置文件,可以根据需要修改.

ruby ProfileSigner.rb 即可

# Bundle命令详解：

### 显示所有的依赖包

bundle show

### 显示指定gem包的安装位置

bundle show [gemname]

### 安装依赖包到项目根目录(在项目目录执行)

bundle install --path vendor/bundle

