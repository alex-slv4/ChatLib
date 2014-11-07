/**
 * Created by kvint on 02.11.14.
 */
package view.communicator {
import feathers.core.IFeathersControl;

import utils.providers.IViewDataProvider;

	public interface ICommunicatorView extends IFeathersControl{

		function get provider():IViewDataProvider;

	}
}
