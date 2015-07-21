

var Notification = React.createClass({

    getInitialState: function() { 
        return{
            hidden: true
        }
    },
    componentDidMount: function(){
        var id_div = "#" + this.props.id
        console.log(this.props.id);
        $(id_div).hide();
    }, 

    show: function(){
        var id_div = "#" + this.props.id
        console.log("Show!");
        if(this.state.hidden){
            $(id_div).show();
            this.setState({hidden : false});
        }
        else{
            $(id_div).hide();
            this.setState({hidden : true});
        }
    },
    
    render: function() {
        var elapsed = Math.round(this.props.timeLeft / 100);

        // This will give a number with one digit after the decimal dot (xx.x):
        var seconds = (elapsed / 10).toFixed(1);    
        return(
        <div className="list-group-item" onClick={this.show}>
        <p> Title: {this.props.title} </p>
            <p> Time left: {seconds} </p>
            <div id={this.props.id}>
            <p> Description: {this.props.descr} </p>
            <p> Date: {this.props.time} </p>
            <p> Song: {this.props.song} </p>
            </div>
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

    getNotifications: function(){
        var that = this;
        $.get( "/index/notifications", function( data ) {
            that.setState({notifications : data});
        });
    },
    getSongs: function(){
        var that = this;
        $.get( "/index/songs", function( data ) {
            that.setState({songs : data});
        });
    },
    componentDidMount: function(){
        this.timer = setInterval(this.tick, 50);
        this.dateT();
        this.getNotifications();
        this.getSongs();
    }, 
    
    getInitialState: function() { 
        return{
            notifications : [],
            songs: [],
            timer: 0,
            inputDescr:"",
            inputDate: "",
            inputTitle:"",
            inputSongs:""
        };
    },

    newEvent: function(){
        var title = this.state.inputTitle;
        var descr = this.state.inputDescr;
        var dateTime = $("#datetimepicker2").find("input").val();
        var song = this.state.inputSongs;

        this.setState({inputTitle : "", inputDescr : "", inputSongs : ""});
        $.post( "/index/create",{title : title, description : descr, date: dateTime, song: song}, function( data ) {
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
            <option> </option>
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
                var id = note.id
                var title = note.title;
                var descr = note.description;
                var time = note.time;
                var song = note.song;
                return <Notification id={id} title={title} descr={descr} time={time} song={song} timeLeft={this.state.timer}/>
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
