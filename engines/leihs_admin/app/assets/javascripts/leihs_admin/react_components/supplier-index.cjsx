@SupplierIndex = React.createClass
  getInitialState: ()->
    {list: null}

  componentDidMount: ()->

    fetchListFromServer 'idorsomething', (res)->
      @setState(list: res)

  render: ()->
    list = state.list or @props.list

    unless state.list
      <div>Not loaded yet…</div>
    else
      state.list.map (item)->
        <SupplierItem supplier={item} key={item.id}/>


@SupplierItem= React.createClass
  render: ()->
    supplier = @props.supplier
    <li>
      {supplier.name}
    </li>
