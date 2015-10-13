React = require('react')

module.exports = React.createClass
  displayName: 'HelloWorld'
  render: (props = @props)->
    <div>
      {props.text}
    </div>
