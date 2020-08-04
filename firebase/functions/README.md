# Firebase functions

Followed [medium post](https://medium.com/icnh/writing-cloud-functions-in-dart-b7e62192b3bc)

## Develop

```sh
pub run build_runner watch -o node:build

npm run serve
```

Add your `service-account.json` to the checkout root.

## Build

### Build Debug (DDC)

```sh
pub run build_runner build --output=build
```

### Build Release (dart2js)

```sh
pub run build_runner build \
  --define="build_node_compilers|entrypoint=compiler=dart2js" \
  --output=build/
```


### Publish

`npm run deploy`