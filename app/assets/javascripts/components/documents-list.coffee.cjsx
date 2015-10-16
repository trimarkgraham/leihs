DocumentsList = React.createClass
  displayName: 'DocumentsList'
  render: ({get} = @props)->

    <div className='content-wrapper straight-top-left'>
    {
      get.map (contract)->
        <DocumentListRow contract={contract} key={contract.id}/>
    }
    </div>

# sub-components. not used anywhere else, so not "exported"
DocumentListRow = React.createClass
  displayName: 'DocumentListRow'
  render: ({contract} = @props)->
    start_date = contract.time_window_min
    end_date = contract.time_window_max

    <div className='row line' data-id={contract.id}>
      <div className='line-col col2of10'>
        <div className='row'>
          <div className='col1of2 text-align-right'>
            <strong>{contract.id}</strong>
          </div>

          <div className='col1of2 text-align-right'>
            {interval(start_date, end_date)}
          </div>
        </div>
      </div>

      <div className='line-col col2of10 text-align-center'>
        {"#{start_date} - #{end_date}"}
      </div>

      <div className='line-col col1of10 text-align-center'
        title={contract.inventory_pool.name}>
        {contract.inventory_pool.shortname}
      </div>

      <div className='line-col col2of10 text-align-left tooltip'
        title={contract.purpose}>
        <div className='max-width-s-alt text-ellipsis'>
          {contract.purpose}
        </div>
      </div>

      <div className='line-col col1of10'>
        {if contract.status is 'signed'
          <span className='badge blue'>
            {'Open'}
          </span>
        }
      </div>

      <div className='line-col line-actions col2of10'>
        <div className='multibutton'>
          <a className='button white text-ellipsis' href={contract.url} target='_blank'>
            <i className='fa fa-file-alt'/>
            {'Contract'}
          </a>

          <div className='dropdown-holder inline-block'>
            <div className='button white dropdown-toggle'>
              <span className='arrow down'></span>
            </div>

            <div className='dropdown right'>
              <a className='dropdown-item text-ellipsis' href={contract.value_list_url} target='_blank'>
                <i className='fa fa-list-ol'></i>
                {'Value List'}
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>


# helper
interval = (start, end)->
  moment(end).diff(start, 'days') + ' Tage'

# "export" it. can later be changed easily into `module.exports = DocumentsList`
window.DocumentsList = DocumentsList
