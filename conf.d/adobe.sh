# Adobe Artifactory sits behind the Banyan zero-trust proxy, whose cert chain is
# anchored by the Adobe Enterprise Root CA. bun/npm don't read the macOS keychain,
# so they reject it (UNABLE_TO_GET_ISSUER_CERT_LOCALLY) without this bundle, which
# includes that root. Regenerate with:
#   security find-certificate -a -p ~/Library/Keychains/login.keychain-db \
#     /Library/Keychains/System.keychain > ~/.adobe-ca-bundle.pem
[[ -r ~/.adobe-ca-bundle.pem ]] && export NODE_EXTRA_CA_CERTS=~/.adobe-ca-bundle.pem

alias klam='klam-ext get'
#export KLAM_MFA_ENABLED=true
export KLAM_PROFILE=AWS_ADTech-prd
