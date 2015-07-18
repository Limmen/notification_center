

var Notification = React.createClass({
    
    componentDidMount: function(){
    }, 

    
    render: function() {
        var elapsed = Math.round(this.props.timeLeft / 100);

        // This will give a number with one digit after the decimal dot (xx.x):
        var seconds = (elapsed / 10).toFixed(1);    
        return(
        <div className="list-group-item">
        <p> Description: {this.props.description} Time: {this.props.time} </p>
            <p> Time left: {seconds} </p>
        </div>
        );
    }
});

var Start = React.createClass({

    tick: function(){
        this.setState({timer: new Date() - this.props.start});
    },

    dateT: function(){
        $(function () {
            $('#datetimepicker2').datepicker({
                locale: 'sv'
            });
        });
    },

    componentDidMount: function(){
        this.timer = setInterval(this.tick, 50);
        this.dateT();
    }, 
    
    getInitialState: function() { 
        return{
            notifications : [{description : "laundry", time : 10}, {description :  "laundry", time : 10}, {description : "laundry", time : 10}, {description : "laundry", time : 10}],
            timer: 0
        };
    },

    
    render: function() {
        return (
            <div>
            <div className="row">
            <div className="col-sm-3"></div>
            <div className="col-sm-6">
            <h1 className="align_center title">Notification Center</h1>
            </div>
            <div className="col-sm-3"></div>
            </div>
            <div className="row">
            <div className="col-sm-1"></div>
            <div className="col-sm-5">
             <h2> Add new event </h2>
            <input type='text' class="form-control" id='datetimepicker2' />
            </div>
            <div className="col-sm-5">
            <div className="list-group">
            <h2> Upcoming events </h2>
            {this.state.notifications.map(function(note) {
                var descr = note.description;
                var time = note.time;
                return <Notification description={descr} time={time} timeLeft={this.state.timer}/>
            }.bind(this))}
            </div>
            </div>
            <div className="col-sm-1"></div>
            </div>
            </div>
        );
    }
});


React.render(
  <Start start={Date.now()}/>,
  document.getElementById('react_container')
);
