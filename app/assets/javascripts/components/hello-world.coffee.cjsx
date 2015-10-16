window.HelloWorld = React.createClass
  displayName: 'HelloWorld'
  render: (props = @props)->
    <div>
      {props.text}
    </div>
