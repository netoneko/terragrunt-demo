# Terragrunt

## State file setup

## Configuration

**FIXME: need to pass ENV to the container**

## Testing

```
curl -Lv $ENDPOINT:80/index.html
```

```
curl -Lv -XPOST -H 'content-type: application/json' -d '{"input":"helllo"}' $ENDPOINT:80/echo
```
