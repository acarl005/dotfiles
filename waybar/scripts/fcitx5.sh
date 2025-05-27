IM=$(qdbus6 org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod)

case $IM in
  keyboard-us)
    OUTPUT=en
    ;;
  pinyin)
    OUTPUT=拼
    ;;
  *)
    OUTPUT='??'
    ;;
esac

echo $OUTPUT
