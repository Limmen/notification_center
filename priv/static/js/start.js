

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
        var that = this;
        $(function () {
            $('#datetimepicker2').datetimepicker({
                locale: 'sv',
//                onSelect: function (data) {
  //                  that.setState({inputDate: data});
    //            }
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
            songs: [{name: "TestSong", artist: "testArtist"}, {name: "TestSong", artist: "testArtist"}, {name: "TestSong", artist: "testArtist"}, {name: "TestSong", artist: "testArtist"}],
            timer: 0,
            inputDescr:"",
            inputDate: "",
            inputTitle:"",
            inputSongs:""
        };
    },

    newEvent: function(){
        var descr = this.state.inputDescr;
        var dateTime = $("#datetimepicker2").find("input").val();
        console.log("Clicked " + descr + "  " + dateTime);
        $.post( "/index/create",{description : descr, date: dateTime}, function( data ) {
            console.log("posted!");
        });
        
    },
    descrChange: function(e){
        console.log("DescrChange");
        this.setState({inputDescr : e.target.value});
    },
    titleChange: function(e){
        this.setState({inputTitle : e.target.value});
    },
    songsChange: function(e){
        this.setState({inputSongs : e.target.value});
    },
    dateChange: function(e){
        console.log("DateChange");
        this.setState({inputDate : e.target.value});
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

            <div className="form-group">
            <label for="not_title">Title:</label>
            <input type="text" className="form-control" id="not_title" value={this.state.inputTitle} onChange={this.titleChange}/>
            </div>
            
            <div className="form-group">
            <label for="descr">Description:</label>
            <input type="text" className="form-control" id="descr" value={this.state.inputDescr} onChange={this.descrChange}/>
            </div>
            
            <div className="form-group">
            <label for="datetimepicker3">Date:</label>
            <div className='input-group date' id='datetimepicker2'>
            <input type='text' className="form-control" id="datetimepicker3" />
            <span className="input-group-addon">
            <span className="glyphicon glyphicon-calendar"></span>
            </span>
            </div>
{/*            <input type='text' className="form-control" id='datetimepicker2'   onChange={this.dateChange}/>  */}
            </div>
            <div className="form-group">
            <label for="songs">Song:</label>
            <select className="form-control" id="songs" value={this.state.inputSongs} onChange={this.songsChange}>
            {this.state.songs.map(function(song) {
                var name = song.name;
                var artist = song.artist;
                return <option>{name} - {artist}</option>
            }.bind(this))}
            </select>
            </div>            
            <button type="submit" className="btn btn-default" onClick={this.newEvent}>Submit</button> 
            
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
