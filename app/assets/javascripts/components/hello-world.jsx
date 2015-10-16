window.HelloWorld = React.createClass({
  displayName: 'HelloWorld',
  render: function () {
    return (
      <div>
        {this.props.text}
      </div>
    )
  }
})
